from django.core.files.storage import FileSystemStorage
from pathlib import Path
from datetime import datetime


class TimestampedFileSystemStorage(FileSystemStorage):
    def get_available_name(self, name, max_length=None):
        path = Path(name)
        if self.exists(name):
            root = path.stem
            suffix = path.suffix
            directory = path.parent

            def generate_name():
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                return directory / f"{root}_{timestamp}{suffix}"

            new_path = generate_name()
            while self.exists(str(new_path)):
                new_path = generate_name()

            return str(new_path)
        return name
