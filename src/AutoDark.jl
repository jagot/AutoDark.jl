module AutoDark

DARK_NOTIFY_RUNNING = false

function auto_dark_apple(fun::Function)
    AutoDark.DARK_NOTIFY_RUNNING && return

    cmd = `dark-notify`
    pin = Base.PipeEndpoint()
    pout = Base.PipeEndpoint()
    perr = Base.PipeEndpoint()
    proc = run(cmd, pin, pout, perr, wait=false)
    process_running(proc) || error("Could not start dark-notify")
    AutoDark.DARK_NOTIFY_RUNNING = true
    @async try
        while !eof(pout) && process_running(proc)
            line = strip(readline(pout))
            !isempty(line) && fun(Symbol(line))
        end
    catch e
        if e isa ProcessFailedException
            println("External process failed:")
            println(e)
        else
            rethrow()
        end
    finally
        close(pout)
        close(pin)
        close(perr)
        AutoDark.DARK_NOTIFY_RUNNING = false
    end
    nothing
end

function auto_dark(fun::Function)
    if Sys.isapple()
        auto_dark_apple(fun)
    else
        error("No support for your OS yet")
    end
end

export auto_dark

end
