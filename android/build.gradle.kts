allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// --- FIXED NAMESPACE INJECTION START ---
subprojects {
    plugins.withType<com.android.build.gradle.api.AndroidBasePlugin> {
        val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
        if (android.namespace == null) {
            android.namespace = project.group.toString()
        }
    }
}
// --- FIXED NAMESPACE INJECTION END ---

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}