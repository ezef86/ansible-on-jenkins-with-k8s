# Despliegue Automatizado con Ansible y AWS

Este proyecto implementa una pipeline de integración y despliegue continuo (CI/CD) utilizando Ansible y AWS. El objetivo es automatizar la provisión, configuración y despliegue de una aplicación web en diferentes entornos (desarrollo, test y producción) de manera eficiente y segura.

## Estructura del Proyecto

- `deploy-webapp.yml`: Playbook principal de Ansible para desplegar la aplicación web.
- `Dockerfile`: Define la imagen Docker utilizada para la aplicación.
- `Jenkinsfile`: Pipeline de Jenkins para orquestar el proceso CI/CD.
- `files/`: Archivos estáticos para cada entorno (`dev`, `test`, `prod`).
- `inventory/`: Inventarios de Ansible para cada entorno.
- `templates/`: Plantillas Jinja2 para la configuración de servicios (por ejemplo, Apache).
- `vars/`: Variables específicas de cada entorno.

## Flujo de la Pipeline

1. **Integración Continua (CI):**
   - Jenkins detecta cambios en el repositorio y ejecuta pruebas automáticas.
   - Se construye la imagen Docker de la aplicación.

2. **Despliegue Continuo (CD):**
   - Ansible se encarga de provisionar la infraestructura en AWS (EC2, S3, etc.).
   - Configura los servicios necesarios (por ejemplo, Apache) usando plantillas.
   - Despliega la aplicación en el entorno correspondiente.

## Requisitos Previos

- Cuenta en AWS con permisos para crear y administrar recursos.
- Jenkins instalado y configurado.
- Docker instalado.
- Ansible instalado (versión 2.9+ recomendada).

## Uso

1. Clona este repositorio.
2. Configura los archivos de inventario y variables según tus credenciales y entornos.
3. Ejecuta el pipeline desde Jenkins o manualmente con Ansible:

   ```bash
   ansible-playbook -i inventory/dev deploy-webapp.yml -e @vars/dev.yml
   ```

4. Accede a la aplicación desplegada en la URL proporcionada por AWS.

## Seguridad
- No almacenes credenciales sensibles en el repositorio.

---

Este proyecto es un ejemplo educativo para prácticas DevOps con Ansible, Jenkins y AWS.
