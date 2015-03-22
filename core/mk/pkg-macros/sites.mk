#
# Define major upstream sites urls
#

#
# SOURCEFORGE
#
embtk_sites_sf_mirrors :=
embtk_sites_sf_mirrors += aarnet
embtk_sites_sf_mirrors += freefr
embtk_sites_sf_mirrors += garr
embtk_sites_sf_mirrors += heanet
embtk_sites_sf_mirrors += hivelocity
embtk_sites_sf_mirrors += ignum
embtk_sites_sf_mirrors += internode
embtk_sites_sf_mirrors += iweb
embtk_sites_sf_mirrors += jaist
embtk_sites_sf_mirrors += kaz
embtk_sites_sf_mirrors += kent
embtk_sites_sf_mirrors += master
embtk_sites_sf_mirrors += nchc
embtk_sites_sf_mirrors += ncu
embtk_sites_sf_mirrors += netcologne
embtk_sites_sf_mirrors += sunet
embtk_sites_sf_mirrors += superb-dca3
embtk_sites_sf_mirrors += switch
embtk_sites_sf_mirrors += tenet
embtk_sites_sf_mirrors += ufpr
embtk_sites_sf_mirrors += waix

embtk_sites_sf        := $(foreach m,$(embtk_sites_sf_mirrors),http://${m}.dl.sourceforge.net/project)
embtk_sites_sf_subdir  = $(addsuffix /$(1),$(embtk_sites_sf))
