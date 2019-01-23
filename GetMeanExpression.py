import loompy
import numpy as np

with loompy.connect(r"loom_files\l5_all.agg.loom") as ds:

    ds.shape
    ds.ra.keys()       # Return list of row attribute names
    ds.ca.keys()       # Return list of column attribute names

    # iss genes
    iss_genes = []
    with open("iss_genes.txt", 'r') as f:
        for row in f:
            iss_genes.append(row.strip('\n'))

    # gene subset
    iGene = []
    for gene in iss_genes:
        i = np.where(ds.ra["Gene"] == gene)
        iGene.append(i[0][0])

    iGene = np.asarray(iGene)
    order = np.argsort(iGene)

    matrix_iss_genes = ds[np.ndarray.tolist(iGene[order]),:]

    # cluster attributes
    cluster_names = ds.ca["ClusterName"]
    likely_location = ds.ca["Probable_location"]
    region = ds.ca["Region"]
    tax1 = ds.ca["TaxonomyRank1"]
    tax2 = ds.ca["TaxonomyRank2"]
    tax3 = ds.ca["TaxonomyRank3"]
    tax4 = ds.ca["TaxonomyRank4"]
    description = ds.ca["Description"]


# write all cell types to tab separated file
with open("All_iss_genes.agg.txt", 'w') as f:
    f.write("gene\t")
    for j in range(np.shape(matrix_iss_genes)[1]):
        f.write("%s-%s\t" % (cluster_names[j], description[j]))
    f.write("\n")
    for i in range(99):
        f.write("%s\t" % iss_genes[order[i]])
        for j in range(np.shape(matrix_iss_genes)[1]):
            f.write("%f\t" % matrix_iss_genes[i,j])
        f.write("\n")


# # cell type subset
# iCells = []
# for i, location in enumerate(region):
#     if "Hippocampus" in location:
#         iCells.append(i)
# matrix_hippocampus= matrix_iss_genes[:,iCells]
# np.shape(matrix_hippocampus)


# # write to tab separated file
# with open("All_iss_genes.agg.txt", 'w') as f:
#     f.write("gene\t")
#     for j in range(np.shape(matrix_hippocampus)[1]):
#         f.write("%s-%s\t" % (cluster_names[iCells[j]], description[iCells[j]]))
#     f.write("\n")
#     for i in range(99):
#         f.write("%s\t" % iss_genes[order[i]])
#         for j in range(np.shape(matrix_hippocampus)[1]):
#             f.write("%f\t" % matrix_hippocampus[i,j])
#         f.write("\n")

