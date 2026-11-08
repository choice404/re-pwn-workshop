# Student environment. Installs the tools and copies in the compiled
# challenges only, no source code, reversing them is the whole point
FROM python:3.8-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
        gdb binutils file vim nano less netcat-openbsd \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir uncompyle6 \
    && useradd -m -s /bin/bash student

WORKDIR /challenges
COPY challenges/ /challenges/
# Fake flag for anyone building this themselves, the published image has the real one
RUN echo 'flag{fake_flag_you_built_this_image_yourself}' > /challenges/flag.txt

# flag.txt is root only, bank and door run as root (setuid) so the only way to
# read the flag is to make one of them print it
RUN chown -R root:root /challenges \
    && chmod 755 /challenges /challenges/keypad \
    && chmod 644 /challenges/vault.pyc \
    && chmod 4755 /challenges/bank /challenges/door \
    && chmod 400 /challenges/flag.txt

# New terminals start in the challenge folder (matters in Codespaces)
RUN echo 'cd /challenges' >> /home/student/.bashrc

USER student
CMD ["/bin/bash"]
