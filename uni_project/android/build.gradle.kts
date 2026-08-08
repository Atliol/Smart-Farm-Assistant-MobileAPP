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

// Subproject အားလုံးကို NDK 25.1.8937393 သို့ သေချာ ပုံသေ သတ်မှတ်ပေးသည့် သန့်ရှင်းသော Kotlin DSL Code
subprojects {
    plugins.withId("com.android.application") {
        extensions.configure<com.android.build.gradle.BaseExtension> {
            ndkVersion = "25.1.8937393"
        }
    }
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.BaseExtension> {
            ndkVersion = "25.1.8937393"
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}