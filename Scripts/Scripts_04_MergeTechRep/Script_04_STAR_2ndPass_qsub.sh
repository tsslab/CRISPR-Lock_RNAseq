cd Script_04_STAR_2ndPass/

sbatch -p batch -n 8 --mem=64G ./Sample_3.sh
sbatch -p batch -n 8 --mem=64G ./Sample_6.sh
sbatch -p batch -n 8 --mem=64G ./Sample_8.sh
sbatch -p batch -n 8 --mem=64G ./Sample_10.sh
sbatch -p batch -n 8 --mem=64G ./Sample_18.sh
