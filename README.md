# 🍦 Bad Objects
 
> *Un Bad Ice Cream hecho con objetos, en Wollok.*
 
## 📖 La historia
 
En la Heladería Bad Objects, donde todo es un objeto y todos responden mensajes, se cortó la luz. El congelador quedó abierto y las frutas se escaparon por los pasillos helados. Para colmo, un grupo de criaturas guardianas patrulla cada rincón y no quiere que nadie se las lleve.
 
Nuestro helado es el único que se anima a ir a buscarlas. Puede levantar muros de hielo para cerrarles el paso a los guardianes (¡y romperlos cuando le estorban!) y, con suerte, encuentra algún turbo por el camino.
 
**Su misión: recuperar todas las frutas de los 4 niveles sin que lo atrapen.**
 
---
 
## 🎮 Cómo se juega
 
| Tecla | Acción |
|---|---|
| ⬅️ ⬆️ ➡️ ⬇️ | Mover al helado |
| `Espacio` | Tirar hielo hacia adelante, o romper el hielo que tengas enfrente |
| `Enter` | Empezar el juego y pasar al siguiente nivel |
| `R` | Reintentar el nivel después de perder |
 
**Objetivo:** comer todas las frutas del nivel. Si un enemigo te toca, perdés.
 
---
 
## 🧩 Mecánicas
 
### 🍓 Frutas
 
| Fruta | Puntos | Detalle |
|---|---|---|
| Frambuesa | 100 | Queda quieta |
| Uva | 200 | Aparece recién cuando comés todas las frutas de la primera fase |
| Kiwi | 300 | Se mueve por un recorrido rectangular |
 
- Cada nivel tiene **dos fases**: primero aparecen las frambuesas y los kiwis, y cuando los comés todos aparecen las uvas (si el nivel las tiene).
- Los **íconos de arriba a la izquierda** se iluminan cuando completás cada tipo de fruta.
- Si una fruta queda debajo de un hielo, se ve congelada y no la podés comer hasta romperlo.
- El puntaje se muestra al completar cada nivel.
### 🧊 Hielo
 
- **Tirar hielo** (`Espacio`): crea bloques en línea recta hacia donde mirás, uno cada 0,2 segundos. La línea se corta al llegar al borde, a una pared, a otro hielo o a un enemigo.
- **Romper hielo** (`Espacio` frente a un bloque): rompe los bloques en línea, de a uno.
- **Hielo resistente:** hace falta romperlo dos veces.
- El hielo **bloquea al helado y a los enemigos**. Los enemigos comunes se dan vuelta cuando chocan con uno.
### 👾 Enemigos
 
Tocar a cualquiera de ellos hace perder el nivel.
 
| Enemigo | Comportamiento |
|---|---|
| Rectangular | Patrulla el borde de un rectángulo. Se da vuelta si choca con hielo o pared |
| Rompehielos | Patrulla igual, pero cuando hay hielo se frena 2 segundos y lo rompe |
| Perseguidor | Va siempre hacia el helado y rodea las paredes. No atraviesa hielo |
| Perseguidor rompehielos | Persigue al helado y rompe el hielo que le tapa el camino |
 
### ⚡ Power-ups
 
| Power-up | Efecto |
|---|---|
| Acelerador | El helado se mueve más rápido durante 10 segundos |
| Relentizador | El helado se mueve más lento durante 10 segundos |
 
Si agarrás uno mientras el otro está activo, **el último que tomás reemplaza al anterior**.
 
### 🏁 Ganar y perder
 
- **Completar un nivel:** aparece una pantalla de continuar. Con `Enter` pasás al siguiente.
- **Perder:** aparece el cartel de game over y con `R` reintentás el nivel (el puntaje se reinicia).
- **Ganar:** al completar el nivel 4 aparece la pantalla de victoria.
---
 
## 🗺️ Niveles
 
| Nivel | Qué hay | Enemigos |
|---|---|---|
| 1 | Frambuesas, uvas y cruces de hielo | 4 rectangulares |
| 2 | Frambuesas y kiwis, con muros de hielo | 2 rompehielos |
| 3 | Frambuesas, uvas y hielo resistente | 2 rectangulares y 1 perseguidor |
| 4 | Frambuesas, uvas, hielo resistente y muchos power-ups | 4 rompehielos y 2 perseguidores rompehielos |

## 👥 Equipo: Bad Objects
 
- Yago Vanzetta
- Julián Pampín
- Catalina Fernandez Presedo
- Mateo Speciali
- Reynnier Arellano
