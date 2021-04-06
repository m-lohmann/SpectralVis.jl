f = open(outfile,"w") # do this once
for i in someloop
    # do something
    write(f, "whatever") # write to stream but not flushed to disk
end
close(f) # now everything is flushed to the disk (i.e. now outfile will have changed)



struct SpecEnvironment
end
# set_specenv
# SPECENV
# set_extrap(env,extr)
# set_extrap(extr)
# set_limits(spec,λmin,Δλ,λmax)
# set_limits(λmin,Δλ,λmax)