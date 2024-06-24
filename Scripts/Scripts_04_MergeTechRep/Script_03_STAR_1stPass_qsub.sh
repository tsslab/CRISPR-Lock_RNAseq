cd Script_03_STAR_1stPass/

sbatch -p batch -n 8 --mem=40G ./Sample_3.sh
sbatch -p batch -n 8 --mem=40G ./Sample_6.sh
sbatch -p batch -n 8 --mem=40G ./Sample_8.sh
sbatch -p batch -n 8 --mem=40G ./Sample_10.sh
sbatch -p batch -n 8 --mem=40G ./Sample_18.sh
