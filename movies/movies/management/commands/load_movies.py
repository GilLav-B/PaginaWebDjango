from django.core.management.base import BaseCommand
from movies.models import Genre, Movie
from django.utils import timezone

class Command(BaseCommand):
    help = 'Carga películas de ejemplo'

    def handle(self, *args, **kwargs):
        Genre.objects.all().delete()
        Movie.objects.all().delete()

        Genre.objects.create(name="Acción")
        Genre.objects.create(name="Drama")

        Movie.objects.create(
            title="Ejemplo de película",
            overview="Una película de prueba.",
            release_date=timezone.now(),
            running_time=120
        )

        self.stdout.write(self.style.SUCCESS('Datos cargados correctamente'))
