"""Contains Rust Language class"""

from os import path


from program_languages.basic import ProgramLanguage


class RustLanguage(ProgramLanguage):
    """Pascal language class"""

    def __init__(self):
        super().__init__()
        self.compiler_path: str = "rustc"

    def get_offset_codes(self):
        return (
            "fn main(){let a: i8 = 0;}",
            "fn main(){loop{}}",
        )

    def get_compile_extension(self):
        return "rs"

    def get_run_extension(self):
        return ""

    def get_memory_usage(self, memory_info):
        return memory_info.data

    def get_cmd_compile(self, folder_path: str, program_name: str):
        return [
            self.compiler_path,
            "-O",
            "--out-dir",
            folder_path,
            path.abspath(
                path.join(folder_path, f"{program_name}.{self.get_compile_extension()}")
            ),
        ]

    def get_cmd_run(self, folder_path: str, program_name: str):
        return [
            path.abspath(path.join(folder_path, f"{program_name}")),
        ]


RUST_LANGUAGE = RustLanguage()
