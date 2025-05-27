# Terraform (OpenTofu)

**YouTube videó:** [Terraform (OpenTofu)](https://www.youtube.com/watch?v=l5k1ai_GBDE&)

## Általános leírás

Automatizálja és menedzseli az infrastruktúrát.

* Open source és deklaratív:
  * Definiálod, milyen végállapotot szeretnél,
  * Ahelyett hogy lépésenként leírnád, mit csináljon a script.

## Mire használható?

Van egy applikációd, és létrehozol hozzá egy infrastruktúrát (Hol fusson az app?).  
Van néhány szervered, amiken mikroservicek futnak. Ezek konténerizált környezetben vannak.  
AWS (Amazon Web Service) az alap, vagy akár Google Cloud is lehet.

### Amit tudsz konfigurálni:

* Privát hálózat  
* Szerver Instance  
* Docker és egyéb toolok (Kubernetes)  
* Security  

## Infrastruktúra biztosítása

* **DevOps**: Infrastruktúra biztosítása  
* **Szoftverfejlesztők**: Alkalmazás Deploy  

## Ansible és Terraform különbségek:

- Mindkettő IaC (Infrastructure as Code), biztosítja, konfigurálja és menedzseli az infrastruktúrát.
- **Terraform** inkább _biztosítja_ az infrastruktúrát.
- **Ansible** inkább _menedzsel_, deployol, installál/updatel szoftvereket.
- Terraform jobb az infrastruktúra létrehozásában, Ansible pedig annak konfigurálásában.

## Infrastruktúra másolása

- DEV environment vs. PROD environment
- Ugyanaz az infrastruktúra, csak a PROD-ra
- Ugyanazt a Terraform kódot tudod erre használni

## Hogyan kapcsolódik a Terraform az AWS-hez?

### 2 fő komponense van:

- **Terraform Core**: ami 2 inputot használ:
  - **TF-Config** (Mit kell csinálni és konfigurálni)
  - **Terraform State** (Aktuális állapota a setupnak)

  → Terv: Mit kell updatelni/létrehozni/törölni  
  → Aktuális állapot és az elvárt állapot leírása

- **Providers**:
  - AWS | Azure | GCP mint IaaS
  - Kubernetes PaaS
  - Fastly SaaS

Ezekhez a Terraformnak hozzáférése van, külön például a Cloud Provideresekhez és külön a Kuberneteshez (pl.: Servicek, Deploymentek és Névterek).

> Viszont a Terraform erőssége még mindig csak az **erőforrások menedzselése**.

### Összefoglalva:

A Core kreál egy végrehajtási tervet az elvárt és az aktuális állapot alapján, amit majd a **Providerek** (Cloud) végrehajtanak.

---

## Deklaratív vs Imperatív megközelítés:

- **Deklaratív**: A végállapotot definiálod
- **Imperatív**: A lépéseket definiálod

### Imperatív konfig fájl:

- Távolíts el 2 servert  
- Hozz létre tűzfal konfigot  
- Adj hozzáférést az AWS usereknek

### Deklaratív konfig fájl:

- 7 szerver  
- Ezzel a tűzfal konfigurációval  
- Ezekkel az user engedélyekkel

---

## Parancsok:

- **Refresh**: Lekérdezed az infrastruktúra providert, mi az aktuális state
- **Plan**: Létrehozzuk, hogy mi az elvárt state, amit végrehajtunk
- **Apply**: Végrehajtjuk
- **Destroy**: Töröljük az erőforrásokat/infrastruktúrát
