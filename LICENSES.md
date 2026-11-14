# What Packmule is made of

Packmule runs on this computer using other people's open work. Each piece and its licence is listed here. All of them allow the app to be used, shared and sold.

## The engine

| Piece | What it does | Licence |
|---|---|---|
| Ollama | Loads the models and runs them | MIT |
| llama.cpp | Runs models inside the engine | MIT |
| MLX | Runs models on Apple chips | MIT |

The engine's own licence files sit beside it in the app's engine folder.

## The models

Models are downloaded from the Ollama library the first time you ask for them. Each one arrives with its licence.

| Model | Used for | Licence it ships with |
|---|---|---|
| Qwen 3.5 4B | Quick | Apache 2.0 |
| Qwen 3.5 9B | Balanced | Apache 2.0 |
| Bonsai 2 27B | Deep | Apache 2.0 |
| Qwen 3 Embedding 0.6B | Finding passages in your files | Apache 2.0 (from its maker's page; no licence file comes with the download) |
| Gemma 4 E2B, E4B and 12B | More models | Apache 2.0 |
| Qwen 3 14B | More models | Apache 2.0 |

## The app

| Piece | What it does | Licence |
|---|---|---|
| pywebview | The window | BSD 3-Clause |
| FastAPI and Starlette | The app's local server | MIT and BSD 3-Clause |
| Uvicorn | Runs the local server | BSD 3-Clause |
| HTTPX | Talks to the engine | BSD 3-Clause |
| Pydantic AI | The agent's step-by-step loop | MIT |
| Pydantic | Checks data | MIT |
| OpenAI Python library | The agent's way of talking to the engine (on this computer only) | Apache 2.0 |
| pypdfium2 and PDFium | Reads PDF files | BSD 3-Clause and Apache 2.0 |
| Pillow | Handles pictures | MIT-CMU |
| NumPy | The sums behind the search | BSD 3-Clause |
| openpyxl | Reads Excel files | MIT |
| psutil | Checks memory and processes | BSD 3-Clause |
| KaTeX | Draws formulas | MIT |

## Fonts and icons

| Piece | Licence |
|---|---|
| Geist | SIL Open Font License 1.1 |
| Space Mono | SIL Open Font License 1.1 |
| JetBrains Mono | SIL Open Font License 1.1 |
| Press Start 2P | SIL Open Font License 1.1 |
| Silkscreen | SIL Open Font License 1.1 |
| Saira Stencil One | SIL Open Font License 1.1 |
| Tabler Icons | MIT |

The pixel art (the nomad, the mule and the opening screens) was drawn for Packmule.
