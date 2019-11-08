wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

"Answer yes to Do you wish the installer to initialize Miniconda3?. conda should now be in your path.""

exec bash
conda config --set auto_activate_base False
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda create --name smake -c bioconda -c conda-forge snakemake=5.4.5

conda activate smake

snakemake -j 999 --use-conda --immediate-submit --notemp --cluster-config cluster.json --cluster 'python3 slurmSubmit.py {dependencies}'
