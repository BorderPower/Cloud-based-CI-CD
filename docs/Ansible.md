
# Ansible

**Forrás:** [YouTube videó](https://www.youtube.com/watch?v=1id6ERvfozo)

Az Ansible egy **IT automatizációs rendszer**.

IT automatizációra használják, többek között:
- operációs rendszerekhez,
- Kubernetes hálózatokhoz,
- biztonsági rendszerekhez,
- kód repókhoz (mint pl. GitHub).

---

## Különbségek a Helm és az Ansible között

📌 [Összehasonlítás – Stackshare](https://stackshare.io/stackups/ansible-vs-helm)

- Különböző szervereken szeretnénk egy applikációt frissíteni pl. **v2.0**-ra.
  - **Dockerrel egyenként** telepíteni/frissíteni → fárasztó
  - **SSH-val konfigurálni** különféle módokon → fárasztó → „What did I do the last time?”
  - Ezért használjuk az **Ansiblet**.

---

## Miért hasznos az Ansible?

1. Végrehajtja a feladatokat **a saját gépedről**.
2. Konfiguráció, telepítés, deployment lépések **egy YAML fájlban** – shell scriptek helyett.
3. **Újrahasznosítható fájlok**, különböző környezetekhez.
4. **Kevesebb hiba** a manuális konfigurációval szemben.

> Használható: operációs rendszereken vagy felhőben  
> (Bare metal infrastruktúra vs. cloud server)

---

## Legnagyobb előny: Agentless

Nem kell minden VM-re külön agentet telepíteni.  
Elég, ha **csak a saját gépeden van telepítve**, és így tudod **menedzselni a szervereket**.

---

## Hogyan működik?

Ansible **modulokat** használ.

📦 Modul példák:
- Indíts egy Docker containert
- Telepíts és indíts el egy Nginx-et
- Fájlok másolása (copy/paste)

🔗 [Modulok listája (Ansible 2.9)](https://docs.ansible.com/ansible/2.9/modules/modules_by_category.html)

Modul példák:
- Jenkins modul
- Docker modul
- PostgreSQL modul

Ezeket **csoportosítva** is lehet futtatni a VM-eken.

---

## Példa (Nginx esetén):

1. Könyvtár létrehozása
2. Nginx telepítése
3. Nginx indítása

---

## Fontos fogalmak

- **Tasks**: Konkrét végrehajtandó feladatok.
- **Hosts**: Mely gépeken történik a végrehajtás?
- **remote_user**: Pl. `root` – a távoli gépen futtatott felhasználó.
- **Indentation**: YAML szigorú behúzásra érzékeny!
- **vars**: Ismétlődő értékek változóként való használata.
- **play**: Meghatározza, hogy:
  - Milyen hostokon
  - Mely felhasználóval
  - Milyen feladatokat hajtson végre.

---

## Playbook

- Egy vagy több **play-t** tartalmazó fájl.
- YAML alapú definíció.

---

## Hosts File

- Inventory lista
- Tartalmazza a kezelt gépek IP-címét vagy nevét.

---

## Docker + Ansible

Ha létrehozol egy play-t Docker containerhez,  
az **több konténerizációs platformra is** telepíthető.

---

## Ansible Tower

- Webes UI dashboard az Ansible-hez.
- Red Hat fejlesztette.
