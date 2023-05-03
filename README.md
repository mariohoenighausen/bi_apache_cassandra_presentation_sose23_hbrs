# Resources for a demonstration held on May 3rd for the BI lecture of the Masters course at HBRS

## Structure of the repository 
[Source of the CSV file (Kaggle)](https://www.kaggle.com/datasets/flenderson/sales-analysis)

[The docker compose file for an apache cassandra cluster with three nodes](docker-compose.yml)

[The CQL setup for the csv file](./db/)

[The csv file with sales historical and active sales data](./data/)

[Python scripts for analyzing, as well as ingesting a csv file inside an apache cassandra node ](./python/)

## Prerequisits

- [Docker](https://www.docker.com)
  - [Apache Cassandra Docker-Image](https://hub.docker.com/_/cassandra/)
- [Conda or in this case miniconda](https://docs.conda.io/en/latest/miniconda.html)
  - [Apache Cassandra Python driver](https://docs.datastax.com/en/developer/python-driver/3.27/installation/)
  - [Pandas](https://pandas.pydata.org)
  - [Numpy](https://numpy.org)

## Presentation rundown

1. Start apache cassandra cluster `docker-compose up`

2. Use nodetool `docker exec -it cassandra-seed-node nodetool status`

3. Use cqlsh `docker exec -it cassandra-seed-node cqlsh`

4. Activate conda environment `conda activate <python-env-name>`

5. Run analysis script `python3 python/analysis.py`

6. Run insert script `python3 python/updated_insert.py`

7. Deactivate conda environment `conda deactivate`

8. Stop apache cassandra cluster`docker-compose down`