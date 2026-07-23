from django.db import models

class Project(models.Model):

    title = models.CharField(max_length=200)

    description = models.TextField()

    image = models.ImageField(upload_to='projects/')

    technologies = models.CharField(max_length=300)

    github_link = models.URLField(blank=True)

    live_demo = models.URLField(blank=True)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title
class Contact(models.Model):

    name = models.CharField(max_length=100)

    email = models.EmailField()

    message = models.TextField()

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name
    

class PersonalInfo(models.Model):
    name = models.CharField(max_length=100)
    # Add this line for the CV upload:
    cv_file = models.FileField(upload_to='cvs/', blank=True, null=True)

    def __str__(self):
        return self.name