import sys
import json

def sentiment(tweet, scores):

    out_score = 0

    # create a list of words from the tweet
    words = tweet.encode("utf-8").split().lower()

    for word in words:
        if " " + word in list(scores.keys()):
            out_score += scores[word]

    return out_score

# create a dictionnary with the words and scores from AFINN-111.txt

afinnfile = open("AFINN-111.txt")
afin_scores = {}

for line in afinnfile:
    term, score = line.split("\t")  # The file is tab-delimited. "\t" means "tab character"
    afin_scores[term] = int(score)  # Convert the score to an integer.

# something like a loop over lines in output.json

json_file = open("output.json")

for line in json_file:

    json_tree = json.loads(line)

    if "lang" in list(json_tree.keys()):
        if json_tree["lang"] != "en":
            continue

    if "text" in list(json_tree.keys()):
        tweet = json_tree["text"]
        tweet_score = sentiment(tweet, afin_scores)
        print(tweet_score)

