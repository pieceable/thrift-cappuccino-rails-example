@import <Foundation/Foundation.j>
@import "TTransport.j"

var DefaultTimeout = 30;

function URLSafeBase64EncodeArray(arr)
{
    var str = CFData.encodeBase64Array(arr);
    str = [str stringByReplacingOccurrencesOfString:"+" withString:"-"];
    str = [str stringByReplacingOccurrencesOfString:"/" withString:"_"];
    return str;
}

function URLSafeBase64DecodeToArray(str)
{
    str = [str stringByReplacingOccurrencesOfString:"-" withString:"+"];
    str = [str stringByReplacingOccurrencesOfString:"_" withString:"/"];
    return CFData.decodeBase64ToArray(str);
}

@implementation THTTPTransport : TTransport
{
    CPString _URL;
    Function _requestFinishedCallback;
    
    CPArray _requestData;
    CPArray _responseData;
    int _responsePosition;
    
    id _activeConnection;
    CPTimer _timeoutTimer;
    
    BOOL _JSONPEnabled;
    int _connectionTimeout;
}

- (id)initWithURL:(CPString)URL {
    if (self = [super init])
    {
        _URL = URL;
        _requestData = [];
        _responseData = [];
        _responsePosition = 0;
        
        _JSONPEnabled = NO;
        _connectionTimeout = 30;
    }
    return self;
}

/*!
    If set to YES, the request will follow the JSONP pattern.  It will be an HTTP GET and
    the request body will be appended with body=<url-safe-base64 encoded body> and there will be
    a 'callback' parameter specifying the name of the JS function to be called.
    
    If set to NO, the request will be an HTTP POST with the request body enoded as url-safe-base64.
    There will be an added 'base64=true' parameter so the server knows the format.
*/
- (void)setJSONPEnabled:(BOOL)JSONPEnabled
{
    _JSONPEnabled = JSONPEnabled;
}

- (BOOL)JSONPEnabled
{
    return _JSONPEnabled;
}

- (void)setConnectionTimeout:(int)seconds
{
    _connectionTimeout = seconds;
}

- (int)connectionTimeout
{
    return _connectionTimeout;
}

- (int)readAll:(CPArray)buffer offset:(int)offset length:(int)length
{
    var bytesAvailable = _responseData.length - _responsePosition;
    
    if (length > bytesAvailable)
    {
        [CPException raise:CPInvalidArgumentException reason:"Asked to read " + length + " bytes, but only " + bytesAvailable + " bytes are available."];
    }
    else
    {
        for (var i = 0; i < length; i++)
        {
            buffer[offset + i] = _responseData[_responsePosition++];
        }
    }
}

- (void)write:(CPArray)buffer offset:(int)offset length:(int)length
{
    if ((offset + length) > buffer.length)
    {
        [CPException raise:CPInvalidArgumentException reason:"(offset + length) == " + (offset + length) + " which is > bufffer.length of " + buffer.length];
    }
    else
    {
        for (var i = 0; i < length; i++)
        {
            [_requestData addObject:buffer[offset + i]];
        }
    }
}

- (void)flush
{
    if (_activeConnection != nil)
    {
        [CPException raise:CPInternalInconsistencyException reason:"Cannot flush transport while a flush is already in progress."];
    }
    else
    {    
        var body = URLSafeBase64EncodeArray(_requestData);
        _requestData = [];
        
        var separator = (_URL.indexOf('?') < 0) ? "?" : "&";
        
        if (_JSONPEnabled)
        {
            var request = [CPURLRequest requestWithURL:_URL + separator + "body=" + body];
            
            _activeConnection = [[CPJSONPConnection alloc] initWithRequest:request callback:"callback" delegate:self startImmediately:YES];
        }
        else
        {
            var request = [CPURLRequest requestWithURL:_URL + separator + "base64=true"];
            [request setHTTPBody:body];
            [request setHTTPMethod:"POST"];
            
            // When doing cross-site HTTP requests, we want to remove any unnecessary HTTP headers so the
            // request won't need to be "pre-flighted".  Mozilla explains it well here:
            // https://developer.mozilla.org/En/HTTP_access_control
            [[request allHTTPHeaderFields] removeAllObjects];
            
            [request setValue:"text/plain" forHTTPHeaderField:"Content-Type"];
            
            _activeConnection = [[CPURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        }

        _timeoutTimer = [CPTimer scheduledTimerWithTimeInterval:DefaultTimeout target:self selector:@selector(connectionTimedOut) userInfo:nil repeats:NO];

        CPLog.info("THTTPTransport: Sent " + body.length + " bytes to " + _URL + " via " + (_JSONPEnabled ? "JSONP" : "POST") + ".");
    }
}

- (void)connection:(id)connection didReceiveData:(CPString)data
{
    var error = nil;

    CPLog.info("THTTPTransport: Received " + data.length + " bytes from " + _URL);

    if (data != nil && [data length] > 0)
    {
        try 
        {
            _responsePosition = 0;
            _responseData = URLSafeBase64DecodeToArray(data);
        }
        catch (e)
        {
            // It probably wasn't valid base64
            error = [CPException exceptionWithName:"TTransportException" reason:"Failed to parse base64 response from server." userInfo:nil];
        }
    }
    else
    {
        error = [CPException exceptionWithName:"TTransportException" reason:"Got empty response from server." userInfo:nil];
    }
    
    [_activeConnection cancel];
    _activeConnection = nil;
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
    
    // This should always be the last thing we do, as the callback could immediately
    // trigger another flush.  We need all our state to be cleaned up before that happens.
    [self performCallbackWithError:error];    
}

- (void)connection:(id)connection didFailWithError:(id)error
{
    _activeConnection = nil;
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;

    // This should always be the last thing we do, as the callback could immediately
    // trigger another flush.  We need all our state to be cleaned up before that happens.
    [self performCallbackWithError:true];
}

- (void)connectionTimedOut
{
    [_activeConnection cancel];
    _activeConnection = nil;
    
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
    
    // This should always be the last thing we do, as the callback could immediately
    // trigger another flush.  We need all our state to be cleaned up before that happens.
    [self performCallbackWithError:[CPException exceptionWithName:"TTransportException" reason:"Timed out while waiting for response." userInfo:nil]];
}

- (void)performCallbackWithError:(id)error
{
    if (_requestFinishedCallback != nil)
    {
        _requestFinishedCallback(error);
    }
    else
    {
        [CPException raise:CPInternalInconsistencyException reason:"Got result from Thrift server but no callback function was set."];
    }
}

- (void)setRequestFinishedCallack:(Function)callback
{
    _requestFinishedCallback = callback;
}

@end