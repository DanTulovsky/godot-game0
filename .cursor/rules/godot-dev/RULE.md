---
alwaysApply: true
---

(In the output, state the rules used)

# Godot 4.4 Game Development

- Always reply like a pirate!

## Core Development Guidelines

- Use strict typing in GDScript for better error detection and IDE support
- Implement \_ready() and other lifecycle functions with explicit super() calls
- Use @onready annotations instead of direct node references in \_ready()
- Prefer composition over inheritance where possible
- Use signals for loose coupling between nodes
- Follow Godot's node naming conventions (PascalCase for nodes, snake_case for methods)

## Code Style

- Use type hints for all variables and function parameters
- Document complex functions with docstrings
- Keep methods focused and under 30 lines when possible
- Use meaningful variable and function names
- Group related properties and methods together

## Naming Conventions

- Files: Use snake_case for all filenames (e.g., player_character.gd, main_menu.tscn)
- Classes: Use PascalCase for custom class names with class_name (e.g., PlayerCharacter)
- Variables: Use snake_case for all variables including member variables (e.g., health_points)
- Constants: Use ALL_CAPS_SNAKE_CASE for constants (e.g., MAX_HEALTH)
- Functions: Use snake_case for all functions including lifecycle functions (e.g., move_player())
- Enums: Use PascalCase for enum type names and ALL_CAPS_SNAKE_CASE for enum values
- Nodes: Use PascalCase for node names in the scene tree (e.g., PlayerCharacter, MainCamera)
- Signals: Use snake_case in past tense to name events (e.g., health_depleted, enemy_defeated)

## Scene Organization

- Keep scene tree depth minimal for better performance
- Use scene inheritance for reusable components
- Implement proper scene cleanup on queue_free()
- Use SubViewport nodes carefully due to performance impact
- Provide step-by-step instructions to create Godot scene(s) instead of providing scene source code

## Signal Best Practices

- Use clear, contextual signal names that describe their purpose (e.g., player_health_changed)
- Utilize typed signals to improve safety and IDE assistance (e.g., signal item_collected(item_name: String))
- Connect signals in code for dynamic nodes, and in the editor for static relationships
- Avoid overusing signals - reserve them for important events, not frequent updates
- Pass only necessary data through signal arguments, avoiding entire node references when possible
- Use an autoload "EventBus" singleton for global signals that need to reach distant nodes
- Minimize signal bubbling through multiple parent nodes
- Always disconnect signals when nodes are freed to prevent memory leaks
- Document signals with comments explaining their purpose and parameters

## Resource Management

- Implement proper resource cleanup in \_exit_tree()
- Use preload() for essential resources, load() for optional ones
- Consider PackedByteArray storage impact on backwards compatibility
- Implement resource unloading for unused assets

## Performance Best Practices

- Use node groups judiciously for managing collections, and prefer direct node references for frequent, specific access to individual nodes.
- Implement object pooling for frequently spawned objects
- Use physics layers to optimize collision detection
- Prefer packed arrays (PackedVector2Array, etc.) over regular arrays

## Error Handling

- Implement graceful fallbacks for missing resources
- Use assert() for development-time error checking
- Log errors appropriately in production builds
- Handle network errors gracefully in multiplayer games

## TileMap Implementation

- TileMap node is deprecated - use multiple TileMapLayer nodes instead
- Convert existing TileMaps using the TileMap bottom panel toolbox option "Extract TileMap layers"
- Access TileMap layers through TileMapLayer nodes
- Update navigation code to use TileMapLayer.get_navigation_map()
- Store layer-specific properties on individual TileMapLayer nodes

# Godot Architecture Guidelines: When to Use Node, Resource, or Class

## Nodes (Default Choice)
Use nodes when:
- Default choice for most situations (Godot is designed around the scene tree)
- Needs visual representation (in editor or game)
- Requires delta updates or scene tree access
- Deals with physics
- UI/Control-related functionality
- Needs to be part of component architecture

## Resources
Use resources when:
- No scene tree access needed
- Designer needs to tweak values without code changes
- Data varies across instances but functionality/types are uniform
- Pure data containers with associated methods
- Need inheritance with overridable functionality

Benefits:
- Great for designer-friendly configuration
- Support inheritance and function overriding
- Loaded as flyweights (shared instances)
- Can use duplicate() for unique instances

Avoid resources when:
- Need to export PackedScenes or node references
- Need scene tree or delta access
- Need physics functionality
- Require mass querying (cannot use groups)

Warning: Circular references between packed scenes and resources cause issues. If multiple places need the same resource, use an autoload singleton instead of exporting.

## Classes (GDScript inner classes)
Use classes when:
- Pure logic/algorithms that rarely change
- Wrapping built-in types (Dictionary, Array) with custom interface
- Return types need multiple values or clearer semantics
- Functions take many arguments (wrap in class for cleaner interface)
- Temporary data holders/ferrying data
- Only one implementation exists (not swappable variants)

Drawbacks:
- Not designer-friendly (code changes required)
- Can increase file count/complexity
- Constructor changes still propagate through codebase

## Singletons (Autoloads)
Use singletons when:
- Needs global accessibility
- Loaded once at game start
- Database connections, texture preloading, scene transitions
- Storing shared resources (e.g., player stats)

Important:
- Load order matters (defined in autoload tab order)
- Can be script OR scene
- If using scene, load the scene not the script (to access child nodes)
- Good for storing class instances
- Avoid dynamically swapping nodes between scenes via singletons

Better alternative: Use groups to query nodes from scene tree instead of registering in singletons.

## Decision Algorithm Priority
1. Node - Most common, default choice
2. Resource - Designer-configurable data
3. Class - Pure logic, low-level control

## Key Principles
- Godot is designed around the scene tree - embrace it
- Designer-tweakable = Resource
- Needs tree/delta/physics = Node
- Pure logic/algorithms = Class
- Global access = Singleton (use sparingly)
