
# Kubernetes – Container Orchestration

**Forrás:** [YouTube – Kubernetes Tutorial](https://www.youtube.com/watch?v=VnvRFRk_51k&list=PLy7NrYWoggjziYQIDorlXjTvvwweTYoNC)

## Mi az a Kubernetes?

A **Kubernetes** egy nyílt forráskódú **konténer-orchestration eszköz**, amely konténerizált alkalmazások kezelésére szolgál különböző környezetekben:

- Fizikai gépeken  
- Virtuális gépeken  
- Felhőszolgáltatásokban (pl. AWS, GCP, Azure)

---

## Milyen problémákra jó a Kubernetes?

- Mikroservice alapú megoldások  
- Növekvő konténerhasználat  
  → Ezeket nehéz manuálisan menedzselni.

---

## Milyen funkciókkal rendelkezik?

- Magas rendelkezésre állás  
- Skálázhatóság  
- Backup és visszaállítás (Disaster recovery)

---

## Kubernetes alap architektúra

- Legalább egy Master (vagy Plane) node, amely több worker node-hoz kapcsolódik (kubelet)  
- A worker node-okon különböző Docker konténerek futnak

---

## Mi fut a master node-on?

A Kubernetes működéséhez szükséges folyamatok:

- **API server** – REST API és interfészek (UI, API, CLI)  
- **Controller manager** – Figyeli és kezeli az állapotváltozásokat  
- **Scheduler** – Eldönti, mely node-on fusson egy pod  
- **etcd** – A Kubernetes "backing store", egy key-value adatbázis

---

## Virtual Network

A master és a worker node-ok ezen keresztül kommunikálnak.  
⚠️ Ha a master node elérhetetlenné válik, a teljes cluster elérhetetlenné válik.

---

## Alapfogalmak

- **Pod** – A konténerek "csomagolása"; 1 pod több konténert is tartalmazhat  
  - Jellemzően 1 pod / alkalmazás:  
    - pl. adatbázis = 1 pod  
    - Node.js app = 1 pod  
    - frontend szerver = 1 pod  
- Minden podnak saját IP-címe van (belső IP)  
- Ha egy konténer leáll a podon belül, automatikusan újraindul  
- Ha maga a pod áll le, új pod jön létre új IP-vel

---

## Konfigurációs modell

A Kubernetes deklaratív módon működik:  
→ A végállapotot írod le (nem az egyes lépéseket, mint az imperatív megközelítésnél)

## Példa egy kubernetes Deployra

Az alap operációs rendszer Fedora. Ezen indítunk majd el egy minikube-t.

    minikube start
Közben Visual Studio Code segítségével létrehozzuk a Node.js appunkat:

```javascript
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello World from Node.js on Kubernetes!');
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
```
Ha kész létrehozzuk a Json-t ami egy konfigurációs file az appunkhoz, illetve egy Docker filet. A docker file segít generálni Docker segítségével az imaget amit majd Docker hubra pusholunk:

```json
{
  "name": "hello-node-k8s",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```


```dockerfile
# Base image
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy app source
COPY . .

# Expose port and start app
EXPOSE 3000
CMD ["npm", "start"]
```
Ha ez mind megvan, akkor következhet a tényleges Kubernetes deploy a már futó szerverünkön. 
Ahhoz, hogy ebbe belekezdjünk 2 filera lesz szükségünk. Egy deployment konfigurációs Yaml kiterjesztésű filera és egy Kubernetes Service konfigurációra ami szintén Yaml kiterjesztésű. 

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-node-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-node
  template:
    metadata:
      labels:
        app: hello-node
    spec:
      containers:
      - name: hello-node
        image: your_dockerhub_name/k8s_test:latest
        ports:
        - containerPort: 3000
```
```yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-node-service
spec:
  type: NodePort
  selector:
    app: hello-node
  ports:
    - port: 80
      targetPort: 3000
      nodePort: 30007
```
2 parancs van amit alkalmazunk kell a gépen ahol fut a kubernetes:

    kubectl apply -f deployment.yaml
Ez a parancs a deployment.yaml file alapján létrehozza a podokat. Ha sikeres, akkor lekérhetjük a podokat a 

    kubectl get pods
paranccsal.

A másik parancs a:

    kubectl apply -f service.yaml
Ugyan így le tudjuk kérni utána a futó serviceket: 

    kubectl get services
Ha kész, akkor láthatjuk az ip-t ahol majd az appunkat el tudjuk érni. Az én esetemben, mivel Virtuális Gépet használtam ezért nekem Port Forwardinggal kellett megoldani, mert a minikube ip-je NAT-olva volt. 

    kubectl port-forward service/hello-node-service 8080:80


