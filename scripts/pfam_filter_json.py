import json
import copy
import argparse

parser = argparse.ArgumentParser(
    #prog='ProgramName',
    description="From an InterProScan output JSON file, generates a new JSON file containg only matches from PFAM database"
)
parser.add_argument("json_file", help="InterProScan output JSON file")
args = parser.parse_args()

# read json file
with open(args.json_file, "r") as f:
    in_json = json.load(f)

# new copy with empty list of matches
out_json = copy.deepcopy(in_json)
out_json["results"][0]["matches"].clear()

# loops original list of matches and adds to new list only the ones fro PFAM database
for match in in_json["results"][0]["matches"]:
    if match["signature"]["signatureLibraryRelease"]["library"] == "PFAM":
        out_json["results"][0]["matches"].append(match)

# print formatted JSON output
print(json.dumps(out_json, indent=4))
