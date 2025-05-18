import ollama
import subprocess
import bcrypt
import os

def is_ollama_running():
        try:
            # Verifica se l'app è in esecuzione tramite AppleScript
            script = 'tell application "System Events" to (name of processes) contains "Ollama"'
            output = subprocess.check_output(
                ["osascript", "-e", script],
                text=True
            ).strip()

            return output == "true"
        except subprocess.CalledProcessError:
            return False
  
def start_ollama():
        try:
            # Avvia l'app tramite il comando "open"
            subprocess.Popen(["open", "-a", "Ollama"])
            print("Ollama avviato.")
        except Exception as e:
            print(f" Errore: {e}")

def call_ai(nameAI: str,prompt: str):
    print(prompt)
    prompt = prompt.encode('utf-8', 'ignore').decode('utf-8')
    client = ollama.Client()
    return client.generate(nameAI, prompt).response
    
def get_ollama_models():
    try:
        # Esegue 'ollama list' in locale (senza connessione)
        result = subprocess.run(
            ["ollama", "list"],
            capture_output=True,
            text=True,
            check=True
        )
        # Estrae i nomi dei modelli dall'output
        models = []
        for line in result.stdout.split('\n')[1:]:  # Salta l'header
            if line.strip():
                model_name = line.split()[0]  # Prende la prima colonna
                models.append(model_name)
        return models
    except Exception as e:
        print(f"Errore: {e}")
        return []
