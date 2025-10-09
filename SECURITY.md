# 🔒 Política de Seguridad - RouWhite

## 📱 Distribución Segura

### ✅ Medidas de Seguridad Implementadas

1. **APK Firmado Digitalmente**

   - Cada APK está firmado con certificado único
   - Verificación automática de integridad
   - Protección contra modificaciones maliciosas

2. **Distribución HTTPS**

   - Todas las descargas via conexión segura
   - Certificados SSL/TLS verificados
   - Protección contra ataques man-in-the-middle

3. **Código Fuente Verificable**

   - Repositorio público en GitHub
   - Historial completo de cambios
   - Builds automáticos y reproducibles

4. **Secrets Protegidos**
   - Claves de Firebase en variables de entorno
   - Keystore encriptado en GitHub Secrets
   - No hay credenciales en código fuente

### 🔍 Verificación de Autenticidad

#### Para Usuarios:

1. **Verificar Origen**

   - Descargar solo desde: `https://gerardoojeda47.github.io/rutasapp/`
   - O desde releases oficiales: `https://github.com/gerardoojeda47/rutasapp/releases`

2. **Verificar Firma Digital**

   ```bash
   # En Android, verificar en Configuración > Aplicaciones > RouWhite > Detalles
   # Debe mostrar: "Firmado por: gerardoojeda47"
   ```

3. **Verificar Permisos**
   - La app solo solicita permisos necesarios
   - Ubicación: Para mostrar rutas cercanas
   - Internet: Para actualizar información de rutas
   - Almacenamiento: Para guardar preferencias

#### Para Desarrolladores:

1. **Verificar Hash del APK**

   ```bash
   sha256sum rouwhite-v*.apk
   # Comparar con hash publicado en release
   ```

2. **Verificar Certificado**
   ```bash
   keytool -printcert -jarfile rouwhite-v*.apk
   ```

### 🚨 Reportar Vulnerabilidades

Si encuentras una vulnerabilidad de seguridad:

1. **NO** la publiques públicamente
2. Envía un email a: `security@rouwhite.com` (si está disponible)
3. O crea un issue privado en GitHub
4. Incluye:
   - Descripción detallada
   - Pasos para reproducir
   - Impacto potencial
   - Versión afectada

### 🛡️ Mejores Prácticas para Usuarios

1. **Instalación Segura**

   - Habilita "Fuentes desconocidas" solo temporalmente
   - Desactívala después de instalar
   - Mantén tu dispositivo actualizado

2. **Uso Seguro**

   - Revisa permisos antes de aceptar
   - Mantén la app actualizada
   - Reporta comportamiento sospechoso

3. **Privacidad**
   - La app no recopila datos personales
   - Ubicación se usa solo localmente
   - No se envían datos a servidores externos

### 🔄 Actualizaciones de Seguridad

- **Automáticas**: La app verifica actualizaciones al iniciar
- **Manuales**: Visita la página de distribución regularmente
- **Críticas**: Se notificarán via GitHub y página web

### 📊 Monitoreo de Seguridad

- **GitHub Security Alerts**: Activadas para dependencias
- **Dependabot**: Actualización automática de dependencias vulnerables
- **Code Scanning**: Análisis automático de código

### 🏆 Reconocimientos

Agradecemos a los investigadores de seguridad que reporten vulnerabilidades de manera responsable.

---

**Última actualización**: Enero 2025
**Versión del documento**: 1.0
**Contacto**: GitHub Issues o Pull Requests
