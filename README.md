# PCSnippets #

A collection of my "this'd be cool to have" work.

## What's Inside? ##

### NSObject+RuntimeAssociations ###
- `- associateWithObject:forKey: and friends`: Creates a runtime link with the given object, via the given key object. Typically, the key is a `void *` set up with `declareRuntimeAssociationKey()`.
- `- associatedObjectForKey:`: Gets the object linked via the given key. This key was set with an association, and is typically gotten with `runtimeAssociationKey()`.
- `- dissassociateWithObjectForKey: and friends`: Breaks a runtime link.

`declareRuntimeAssociationKey()`:  Declares a `static void *` for the association key.
`runtimeAssociationKey()`: Gets the `static void *` association key.

### Objectify ###
- `$()`: Makes an object out of the given value.

### PCContainerComprehension ###
- `- arrayByComprehendingWithBlock:`: Creates a new array with the return value of the block, executed for each element in the array. `nil` values will be skipped.
- `- dictionaryByComprehendingWithBlock:`: Creates a new dictionary with the return value of the block, executed for each key in the dictionary. `nil` values will be skipped.

- `- isJSONSerializable`: Returns `YES` if the object is a valid JSON object. 
- `- JSONSerialize`: Returns a string of JSON, which represents a dictionary of this object's property name - property value pairs.
- `- JSONRepresentation`: Returns a string of JSON, which represents this object.
- `- JSONDumpWithBlock: and friends`: Returns a string of JSON, which represents the object returned from the block, selector, etc.

- `- JSONValue`: Returns a valid JSON object, parsed from this string.