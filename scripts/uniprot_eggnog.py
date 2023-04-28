import requests
import sys

uniprot_API = "https://rest.uniprot.org/"


# function adapted from Uniprot webinar
def get_url(url, **kwargs):
    """
    Function to handle status codes other than 200
    """
    response = requests.get(url, **kwargs)

    if not response.ok:
        print(response.text)
        response.raise_for_status()
        sys.exit()

    return response


def results_page_stream(paginated: bool) -> str:
    """
    Function for choosing the results format:
        paginated or a single stream.
    """
    if paginated:
        # paginated results
        results_format = "search"
    else:
        # results in one unique stream
        results_format = "stream"
    return results_format


def get_uniprot(query: str, pages=False) -> requests.models.Response:
    """
    Function to retrieve results from Uniprot based on a query statement

    Arguments
        query       String, Uniprot formatted query
                    (see https://www.uniprot.org/help/text-search)
        pages       Bool, to get results organised in pages or a single stream
                    (Default False, single stream)

    Return a Response object
    """
    # paginated results or single stream
    search = results_page_stream(pages)

    # full url
    url = f"{uniprot_API}/uniprotkb/{search}?query={query}"

    # get query
    response = get_url(url)

    return response


if __name__ == "__main__":
    # Uniprot query
    query = [
        # eggNOG orthologous grooup COG5002 search term
        "xref:eggnog-COG5002", 
        # filter by Mycobacteriaceae taxon id
        "taxonomy_id:1762"]
    
    # join query terms
    query = " AND ".join(["(" + i + ")" for i in query])
    # add format output: fasta
    query += "&format=fasta"
    
    # Uniprot search
    r = get_uniprot(query)

    # save output to file
    fname = "data/uniprot_COG5002_1762.faa"
    with open(fname, "w") as f:
        f.write(r.text)
    
    # return number of entries
    seq_n = len(
            [line for line in r.text.splitlines() if ">" in line]
    )
    print(f"{seq_n} sequences written to file '{fname}'")
