module EscherTodo

using FunctionalCollections
using Reactive
using Escher

# This is an example app to demonstrate Components

include("item.jl")
include("list.jl")

function load_list()
    TodoList("Todo",
        pvec([TodoItem(false, "Make presentation"),
              TodoItem(false, "Don't lose it")]))
end

function app(window)
    input = Signal(Any, nothing)

    list = foldp(load_list(), input) do lst, action
        @show update(lst, action)
    end

    map(list) do l
        view(l) >>> input
    end
end

function debug_app(window)
    input = Signal(Any, nothing)
    idx_signal = Signal(Int, 1)

    list = foldp(load_list(), input) do lst, action
        @show update(lst, action)
    end

    history = foldp(push, pvec(Any[value(list)]), list)
    current_index = merge(map(length, history), idx_signal)


    map(current_index, history) do i, hist
        vbox(
            hbox("Recorded states: ",
                 slider(1:length(hist),
                        value=length(hist)) >>> idx_signal
            ) |> packacross(center),
            view(hist[i]) >>> input
        )
    end
end

end # module
