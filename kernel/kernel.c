// kernel.c
void kernel_main() {
    const char *message = "Hello from Kernel!";
    char *video_memory = (char *)0xB8000;
    for(int i = 0; message[i] != '\0'; i++) {
        video_memory[i*2] = message[i];
        video_memory[i*2+1] = 0x07; // Атрибут цвета
    }
    while(1);
}

