import sys
import json
import numpy

def sentiment(tweet, scores):

    out_score = 0

    for word in list(scores.keys()):
        if " " + word in tweet:
            out_score += scores[word]

    return out_score

def term_average_score(term, scores):

    term = " " + term
    possible_terms = [term + " ", term + "!", term + "?", term + "."]

    # something like a loop over lines in output.json

    json_file = open("output.json")

    average_score = []

    for line in json_file:

        json_tree = json.loads(line)

        if "lang" in list(json_tree.keys()):
            if json_tree["lang"] != "en":
                continue

        if "text" in list(json_tree.keys()):
            tweet = json_tree["text"]
            if not any(term in tweet.lower() for term in possible_terms):
                continue
            tweet_score = sentiment(tweet.lower(), scores)
            average_score.append(tweet_score)

    json_file.close()

    if len(average_score) == 0:
        return 0
    else:
        return numpy.mean(average_score)

# create a dictionnary with the words and scores from AFINN-111.txt

afinnfile = open("AFINN-111.txt")
afin_scores = {}

for line in afinnfile:
    term, score = line.split("\t")  # The file is tab-delimited. "\t" means "tab character"
    afin_scores[term] = int(score)  # Convert the score to an integer.

terms_list = ["football", "obama"]

for target_term in terms_list:
    target_term = target_term.lower()

    if target_term in list(afin_scores.keys()):
        print("Term already in AFIN-111.txt.")
        print(target_term, afin_scores[target_term])
    else:
        score = term_average_score(target_term, afin_scores)
        print(target_term, score)
