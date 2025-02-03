# Étape 1 : Compilation avec Maven
FROM maven:3.9.8-eclipse-temurin-21 AS build
WORKDIR /app

# Copier les fichiers nécessaires au build
COPY pom.xml .
COPY src ./src

# Construction de l'application
RUN mvn clean package -DskipTests

# Vérifier si le .jar est bien généré
RUN ls -l target/

# Étape 2 : Exécution avec OpenJDK
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copier le fichier JAR compilé depuis l’étape précédente
COPY --from=build /app/target/*.jar app.jar

# Exposer le port de l'application
EXPOSE 8080

# Lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]

