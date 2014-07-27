import oauth2 as oauth
import urllib2 as urllib
import json

# See assignment1.html instructions or README for how to get these credentials

api_key = "jdhWEyNSGG5jF31ZFblBzf6kY"
api_secret = "hMR0VLRZio7K3rn5kLqDR4mLY4UrmZ3dHW3GahZD7ui6TaS78d"
access_token_key = "592741958-dX6HaZBO9b14xzfnlHdTU1hQnywalKHG9IKHmotC"
access_token_secret = "5y6a1J6bK3TKbYk7W9ke7fwMdFZLvuymiMXBEIfbqjr58"

_debug = 0

oauth_token = oauth.Token(key=access_token_key, secret=access_token_secret)
oauth_consumer = oauth.Consumer(key=api_key, secret=api_secret)

signature_method_hmac_sha1 = oauth.SignatureMethod_HMAC_SHA1()

http_method = "GET"


http_handler = urllib.HTTPHandler(debuglevel=_debug)
https_handler = urllib.HTTPSHandler(debuglevel=_debug)

'''
Construct, sign, and open a twitter request
using the hard-coded credentials above.
'''
def twitterreq(url, method, parameters):

    req = oauth.Request.from_consumer_and_token(oauth_consumer,
                                             token=oauth_token,
                                             http_method=http_method,
                                             http_url=url,
                                             parameters=parameters)

    req.sign_request(signature_method_hmac_sha1, oauth_consumer, oauth_token)

    #headers = req.to_header()

    if http_method == "POST":
        encoded_post_data = req.to_postdata()
    else:
        encoded_post_data = None
        url = req.to_url()

    opener = urllib.OpenerDirector()
    opener.add_handler(http_handler)
    opener.add_handler(https_handler)

    response = opener.open(url, encoded_post_data)

    return response

url = "https://api.twitter.com/1.1/search/tweets.json?q=microsoft&count=1"

response = twitterreq(url, "GET", [])

print json.load(response)