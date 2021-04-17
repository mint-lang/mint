# Language Server

This folder contains the code for the language server.

## Features

The feature set is pretty miminal at this point:

| Name                          | Support                       | Description                                   |
|:------------------------------|:------------------------------|:----------------------------------------------|
| Hover                         | :heavy_check_mark:            | Type information for entities                 |
| Completion                    | :heavy_check_mark:            | Components, functions, etc..., based on scope |
| Diagnostics                   | :negative_squared_cross_mark: |                                               |
| Text Document Synchronization | :heavy_check_mark:            | Full files only                               |
| Signature Help                | :negative_squared_cross_mark: |                                               |
| Goto Declaration              | :negative_squared_cross_mark: |                                               |
| Goto Type Definition          | :negative_squared_cross_mark: |                                               |
| Goto Implementation           | :negative_squared_cross_mark: |                                               |
| Find References               | :negative_squared_cross_mark: |                                               |
| Document Highlights           | :negative_squared_cross_mark: |                                               |
| Document Symbols              | :negative_squared_cross_mark: |                                               |
| Code Action                   | :negative_squared_cross_mark: |                                               |
| Code Lens                     | :negative_squared_cross_mark: |                                               |
| Document Link                 | :negative_squared_cross_mark: |                                               |
| Document Color                | :negative_squared_cross_mark: |                                               |
| Formatting                    | :heavy_check_mark:            | Full files only                               |
| Rename                        | :negative_squared_cross_mark: |                                               |
| Folding Range                 | :negative_squared_cross_mark: |                                               |
| Selection Range               | :negative_squared_cross_mark: |                                               |
| Call Hierarchy                | :negative_squared_cross_mark: |                                               |
| Semantic Tokens               | :negative_squared_cross_mark: |                                               |
| Monikers                      | :negative_squared_cross_mark: |                                               |

## Implementation

See [Language Server Protocol](../lsp).
