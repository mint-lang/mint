# Language Server

This folder contains the code for the language server.

## Features

The feature set is pretty minimal at this point:

| Name                          | Support                       | Description                                   |
| :---------------------------- | :---------------------------- | :-------------------------------------------- |
| Hover                         | :heavy_check_mark:            | Type information for entities                 |
| Completion                    | :heavy_check_mark:            | Components, functions, etc..., based on scope |
| Diagnostics                   | :negative_squared_cross_mark: |                                               |
| Text Document Synchronization | :heavy_check_mark:            | Full files only                               |
| Signature Help                | :negative_squared_cross_mark: |                                               |
| Goto Declaration              | :negative_squared_cross_mark: |                                               |
| Goto Type Definition          | :negative_squared_cross_mark: |                                               |
| Goto Implementation           | :heavy_check_mark:            | Some entities                                 |
| Find References               | :negative_squared_cross_mark: |                                               |
| Document Highlights           | :negative_squared_cross_mark: |                                               |
| Document Symbols              | :negative_squared_cross_mark: |                                               |
| Code Action                   | :heavy_check_mark:            | Source Only (see specific section)            |
| Code Lens                     | :negative_squared_cross_mark: |                                               |
| Document Link                 | :negative_squared_cross_mark: |                                               |
| Document Color                | :negative_squared_cross_mark: |                                               |
| Formatting                    | :heavy_check_mark:            | Full files only                               |
| Rename                        | :negative_squared_cross_mark: |                                               |
| Folding Range                 | :heavy_check_mark:            | Specific entities only                        |
| Selection Range               | :negative_squared_cross_mark: |                                               |
| Call Hierarchy                | :negative_squared_cross_mark: |                                               |
| Semantic Tokens               | :heavy_check_mark:            | Full document only                            |
| Monikers                      | :negative_squared_cross_mark: |                                               |

### Code Action

These are the supported code actions:

* Order Entities (Module) - Orders entities in a module alphabetically, constants first then
  modules, other comments are not reordered, formats the whole file.

## Implementation

See [Language Server Protocol](../lsp).
