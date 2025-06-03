# 🧠 AI Manager: Swift ↔ Python ↔ Ollama

**Un gestore leggero per l'integrazione di modelli AI nei progetti Swift, con bridge tra codice nativo, Python e Ollama. Tutto in locale.**

---

## 🔧 Tech Stack
- **Core**: Swift (performance nativa) + Python tramite [PythonKit](https://github.com/pvieito/PythonKit)  
- **AI Engine**: [Ollama](https://ollama.com/) (gestione modelli AI locali)  
- **UI**: SwiftUI (dichiarativa e moderna)  

---

## 🚀 Funzionalità
- Comunicazione fluida tra Swift e Python  
- Controllo completo dei modelli Ollama (caricamento, esecuzione, switch)  
- Interfaccia SwiftUI per gestione modelli e interazioni  
- Funziona interamente in locale  

---

## 📦 Requisiti
- macOS 14+  
- Xcode 15+  
- Python 3.10+  
- [Ollama installato](https://ollama.com/)  
- `pip install ollama`  

---

## ⚙️ Architettura

```text
Swift (UI & Logic) ↔ Python (Bridge) ↔ Ollama (AI Model)

