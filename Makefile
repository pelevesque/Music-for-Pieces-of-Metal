# Usage: ▸
# 	make ｢file nick｣
# 	make ⦃ang⦄

	# Obtain the project's directory, which is the one where this
	# Makefile resides.
dPrj := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

	# Where the score files are.
dDat := $(dPrj)/scores

	# Where to place the generated files, and ensure that directory's
	# presence.
dGen := $(dPrj)/gen
$(shell test -d $(dGen) || mkdir -p $(dGen))

# --------------------------------------------------------------------
default:
	@echo "Missing target, one of: ang gen gon sel sem"

	# Our five targets.
ang: $(dGen)/angklung.01.svg
gen: $(dGen)/gender.01.svg
gon: $(dGen)/gong-kebyar.01.svg
sel: $(dGen)/selunding.01.svg
sem: $(dGen)/semar-pegulingan.01.svg

$(dGen)/%.01.svg: $(dPrj)/main.raku $(dDat)/%.score
	$(word 1,$^) $(word 2,$^) $(dGen)
