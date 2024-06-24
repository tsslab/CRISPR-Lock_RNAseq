cd Script_03_MT/

# Single sequencing
sbatch -p batch -n 8 --mem=8G ./Sample_11.sh
sbatch -p batch -n 8 --mem=8G ./Sample_12.sh
sbatch -p batch -n 8 --mem=8G ./Sample_13.sh
sbatch -p batch -n 8 --mem=8G ./Sample_14.sh
sbatch -p batch -n 8 --mem=8G ./Sample_15.sh
sbatch -p batch -n 8 --mem=8G ./Sample_16.sh
sbatch -p batch -n 8 --mem=8G ./Sample_17.sh
sbatch -p batch -n 8 --mem=8G ./Sample_19.sh
sbatch -p batch -n 8 --mem=8G ./Sample_1.sh
sbatch -p batch -n 8 --mem=8G ./Sample_20.sh
sbatch -p batch -n 8 --mem=8G ./Sample_21.sh
sbatch -p batch -n 8 --mem=8G ./Sample_22.sh
sbatch -p batch -n 8 --mem=8G ./Sample_23.sh
sbatch -p batch -n 8 --mem=8G ./Sample_24.sh
sbatch -p batch -n 8 --mem=8G ./Sample_25.sh
sbatch -p batch -n 8 --mem=8G ./Sample_26.sh
sbatch -p batch -n 8 --mem=8G ./Sample_27.sh
sbatch -p batch -n 8 --mem=8G ./Sample_2.sh
sbatch -p batch -n 8 --mem=8G ./Sample_4.sh
sbatch -p batch -n 8 --mem=8G ./Sample_5.sh
sbatch -p batch -n 8 --mem=8G ./Sample_7.sh
sbatch -p batch -n 8 --mem=8G ./Sample_9.sh

# Multi sequencing
sbatch -p batch -n 8 --mem=8G ./Sample_10_techrep_1.sh
sbatch -p batch -n 8 --mem=8G ./Sample_10_techrep_2.sh
sbatch -p batch -n 8 --mem=8G ./Sample_18_techrep_1.sh
sbatch -p batch -n 8 --mem=8G ./Sample_18_techrep_2.sh
sbatch -p batch -n 8 --mem=8G ./Sample_3_techrep_1.sh
sbatch -p batch -n 8 --mem=8G ./Sample_3_techrep_2.sh
sbatch -p batch -n 8 --mem=8G ./Sample_6_techrep_1.sh
sbatch -p batch -n 8 --mem=8G ./Sample_6_techrep_2.sh
sbatch -p batch -n 8 --mem=8G ./Sample_8_techrep_1.sh
sbatch -p batch -n 8 --mem=8G ./Sample_8_techrep_2.sh
