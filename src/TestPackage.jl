module TestPackage

using Logging
using HDF5

# package code goes here

"""
If running non-interactively, call `exit(expr)`, reporting any exceptions

Use this for deploying command line tools written in julia.
"""
macro run_if_deployed(expr)
    quote
        # Hack to force serialization of package precompilation during package
        # install on 0.4 prerelease.  See
        # https://github.com/JuliaLang/julia/issues/12508
        do_precompile = length(ARGS) > 0 && ARGS[1] == "__precompile__"
        if !do_precompile
            try
                if !isinteractive()
                    blas_set_num_threads(1)
                    exit($(esc(expr)))
                end
            catch err
                bt = catch_backtrace()
                io = IOBuffer()
                showerror(io, err, bt)
                println(STDERR, "ERROR: Caught $(typeof(err)):\n$(takebuf_string(io))")
                exit(1)
            end
        end
    end
end

end # module
