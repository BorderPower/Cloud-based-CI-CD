import subprocess
import os
import json
import yaml
import random
from pathlib import Path

def colored(text):
    colors = ['\033[32m', '\033[33m', '\033[34m', '\033[35m', '\033[36m', '\033[37m', '\033[90m', '\033[92m',
              '\033[93m', '\033[94m', '\033[95m', '\033[96m', '\033[38;5;45m', '\033[38;5;93m', '\033[38;5;190m',
              '\033[38;5;208m', '\033[38;5;129m', '\033[38;5;202m', '\033[38;5;226m', '\033[38;5;201m',
              '\033[38;5;240m', '\033[38;5;33m', '\033[38;5;66m', '\033[38;5;105m', '\033[38;5;154m', '\033[38;5;25m',
              '\033[38;5;147m', '\033[38;5;159m', ]
    RESET = "\033[0m"
    return random.choice(colors) + text + RESET

def banner_block():
    """Block style banner"""
    return colored("""
███████╗████████╗ █████╗  ██████╗██╗  ██╗████████╗ ██████╗ ██████╗ ██╗   ██╗███████╗
██╔════╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝╚══██╔══╝██╔═══██╗██╔══██╗██║   ██║██╔════╝
███████╗   ██║   ███████║██║     █████╔╝    ██║   ██║   ██║██████╔╝██║   ██║███████╗ 
╚════██║   ██║   ██╔══██║██║     ██╔═██╗    ██║   ██║   ██║██╔═══╝ ██║   ██║╚════██║
███████║   ██║   ██║  ██║╚██████╗██║  ██╗   ██║   ╚██████╔╝██║     ╚██████╔╝███████║
╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝      ╚═════╝ ╚══════╝⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
""")
print(banner_block())

# Tofu config & playbook location
base_dir = Path(__file__).parent.resolve()
terraform_dir =  base_dir / "opentofu"
playbook_dir = base_dir  / "ansible"
plan_file = os.path.join(terraform_dir, "plan.out")
inventory_file_path = os.path.join(playbook_dir, "inventory.yml")
playbook_path = os.path.join(playbook_dir, "k8s-playbook.yml")

# 1. Init
print(colored("🚀 Starting 'tofu init'..."))
subprocess.run(["tofu", "init"], cwd=terraform_dir, check=True)
while True:
    response = input(colored("✅ 'tofu init' completed. Type 'yes' to boldly continue: ")).strip().lower()
    if response == "yes":
        break
    print(colored("🤖 Incorrect incantation. Type 'yes' to proceed!"))

# 2. Plan
print(colored("🔮 Executing 'tofu plan'... preparing to foresee infrastructure..."))
subprocess.run(["tofu", "plan", "-out", plan_file], cwd=terraform_dir, check=True)
while True:
    response = input(colored("✅ 'tofu plan' complete. Type 'yes' to approve this prophetic vision: ")).strip().lower()
    if response == "yes":
        break
    print(colored("🙃 The prophecy awaits a 'yes'..."))

# 3. Apply
print(colored("⚒️  Applying your infrastructure like a Terraforming wizard..."))
subprocess.run(["tofu", "apply", "-auto-approve", plan_file], cwd=terraform_dir, check=True)

# 4. Output
print(colored("📦 Collecting outputs from the void..."))
result = subprocess.run(["tofu", "output", "-json"], cwd=terraform_dir, capture_output=True, text=True, check=True)
outputs = json.loads(result.stdout)

# 5. JSON, IP address
ip_output_keys = ["vm_ips"]
ip_addresses = []

for key in ip_output_keys:
    if key in outputs:
        value = outputs[key]["value"]
        if isinstance(value, list):
            ip_addresses.extend(value)
        else:
            ip_addresses.append(value)

# 6. YAML inventory
inventory = {
    "all": {
        "children": {
            "masters": {
                "hosts": {
                    ip_addresses[0]: {
                        "ansible_user": "ubuntu",
                        "ansible_ssh_private_key_file": "~/.ssh/id_rsa"
                    }
                }
            },
            "workers": {
                "hosts": {
                    ip: {
                        "ansible_user": "ubuntu",
                        "ansible_ssh_private_key_file": "~/.ssh/id_rsa"
                    } for ip in ip_addresses[1:]
                }
            }
        }
    }
}

with open(inventory_file_path, "w") as f:
    yaml.dump(inventory, f, default_flow_style=False)

print(colored(f"📜 Ansible inventory has been generated: {inventory_file_path}"))

# 7. Run Ansible
while True:
    valasz = input(colored("🧙 Shall we summon the Ansible Playbook as well? Type 'yes' to invoke the magic: ")).strip().lower()
    if valasz == "yes":
        break
    print(colored("⛔️ Incorrect ritual words. Please say 'yes'."))

print(colored("🌀 Running Ansible Playbook... Servers will soon obey."))
subprocess.run(["ansible-playbook", "-i", inventory_file_path, playbook_path], check=True)

# Outro
print(colored("🎉 All done! Infrastructure and configuration complete. Go grab a coffee ☕️."))
