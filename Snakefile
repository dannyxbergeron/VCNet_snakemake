import os

configfile: "config.json"

num_split = [x for x in range(31)]

rule all:
    input:
        os.path.join(config["path"]["merged_corr"], "VCNet_sno_corr.tsv")

rule split_sno:
    input:
        config["raw_files"]["sno_raw_file"]
    conda:
        "envs/pandas.yaml"
    output:
        temp(
            expand(
                os.path.join(config["path"]["split_sno"], "sno_{num}.tsv"),
                num=num_split
            )
        )
    script:
        "scripts/split.py"

rule vcnet:
    input:
        sno_files = os.path.join(config["path"]["split_sno"], "sno_{num}.tsv"),
        other_file = config["raw_files"]["other_raw_file"]
    output:
        temp(
                os.path.join(config["path"]["split_corr"], "sno_corr_{num}.tsv")
            )
    conda:
        "envs/r.yaml"
    shell:
        "Rscript scripts/launcher.R {input.sno_files} {input.other_file} {output}"

rule merge_corr:
    input:
        expand(
            os.path.join(config["path"]["split_corr"], "sno_corr_{num}.tsv"),
            num=num_split
            )
    output:
        os.path.join(config["path"]["merged_corr"], "VCNet_sno_corr.tsv")
    conda:
        "envs/pandas.yaml"
    script:
        "scripts/merge_corr.py"
