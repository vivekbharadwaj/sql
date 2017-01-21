.separator ","

CREATE TABLE papers (
    id INTEGER PRIMARY KEY,
    year INTEGER,
    title TEXT,
    event_type TEXT,
    pdf_name TEXT,
    abstract TEXT,
    paper_text TEXT);

CREATE TABLE authors (
    id INTEGER PRIMARY KEY,
    name TEXT);

CREATE TABLE paper_authors (
    id INTEGER PRIMARY KEY,
    paper_id INTEGER,
    author_id INTEGER);

.import "DATA\\papers_noheaders.csv" papers
.import "DATA\\authors_noheaders.csv" authors
.import "DATA\\paper_authors_noheaders.csv" paper_authors

CREATE INDEX paperauthors_paperid_idx ON paper_authors (paper_id);
CREATE INDEX paperauthors_authorid_idx ON paper_authors (author_id);