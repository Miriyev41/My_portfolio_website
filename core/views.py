from django.shortcuts import render, redirect
from .models import Project, Contact

def home(request):

    projects = Project.objects.all().order_by('-created_at')

    if request.method == 'POST':

        name = request.POST.get('name')
        email = request.POST.get('email')
        message = request.POST.get('message')

        Contact.objects.create(
            name=name,
            email=email,
            message=message
        )

        return redirect('/')

    return render(request, 'core/index.html', {
        'projects': projects
    })