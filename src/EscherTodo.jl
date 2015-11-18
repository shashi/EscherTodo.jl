module EscherTodo

using FunctionalCollections
using Reactive
using Escher

# This is an example app to demonstrate Components

abstract Component
abstract Action

include("item.jl")
include("todolist.jl")

function load_list()
    TodoList("TODO",
        pvec([TodoItem(false, "Create universe"),
              TodoItem(false, "Make pie")]))
end

function app(window)
    input = Input{Any}(nothing)
    list = foldl(load_list(), input) do lst, action
        update(lst, action)
    end
    lift(list) do l
        view(l) >>> input
    end
end

end # module