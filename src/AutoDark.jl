module AutoDark

DARK_NOTIFY_RUNNING = false

function proc_line_based(fun::Function, cmd::Cmd, output::AbstractDict)
    AutoDark.DARK_NOTIFY_RUNNING && return

    pin = Base.PipeEndpoint()
    pout = Base.PipeEndpoint()
    perr = Base.PipeEndpoint()
    proc = run(cmd, pin, pout, perr, wait=false)
    process_running(proc) || error("Could not start $cmd")
    AutoDark.DARK_NOTIFY_RUNNING = true
    Threads.@spawn try
        while !eof(pout) && process_running(proc)
            line = strip(readline(pout))
            !isempty(line) && fun(get(output, line, :unknown))
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

function auto_dark_apple(fun::Function)
    output = Dict(
        "light" => :light,
        "dark" => :dark,
    )
    proc_line_based(fun, `dark-notify`, output)
end

function auto_dark_gnome(fun::Function)
    output = Dict(
        "color-scheme: 'default'" => :light,
        "color-scheme: 'prefer-light'" => :light,
        "color-scheme: 'prefer-dark'" => :dark,
    )
    cmd = `gsettings monitor org.gnome.desktop.interface color-scheme`
    proc_line_based(fun, cmd, output)
end

function isgnome()
    Sys.islinux() || return false
    get(ENV, "XDG_CURRENT_DESKTOP", "") == "GNOME"
end

function auto_dark(fun::Function)
    if Sys.isapple()
        auto_dark_apple(fun)
    elseif isgnome()
        auto_dark_gnome(fun)
    else
        error("No support for your OS/desktop yet")
    end
end

export auto_dark

end
