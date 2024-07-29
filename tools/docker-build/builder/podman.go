package builder

import (
	"fmt"
	"os"
	"strings"
)

var _ runtime = &Podman{}

type Podman struct {
	args   Args
	execFn execFn
}

func NewPodman() *Podman {
	return &Podman{
		execFn: execCmd,
	}
}

func (p *Podman) WithArgs(a Args) runtime {
	p.args = a
	return p
}

func (p *Podman) Build() error {
	var (
		options = []string{"build"}
		targets = []string{}
	)

	if p.args.Dockerfile != "" {
		options = append(options, "-f", p.args.Dockerfile)
	}

	if p.args.NoCache {
		options = append(options, "--no-cache")
	}

	if p.args.BuildArgs != "" {
		buildArgs := strings.TrimLeft(p.args.BuildArgs, "--build-arg")
		options = append(options, "--build-arg", buildArgs)
	}

	target := fmt.Sprintf("%s:%s", p.args.ImageName, p.args.Tag)
	targets = append(targets, target)
	if p.args.Platform != "" {
		options = append(options, "--platform", p.args.Platform)
		options = append(options, "--manifest", target)
	} else {
		options = append(options, "--tag", target)
		if len(p.args.Tags) > 0 {
			for _, tag := range p.args.Tags {
				tag = strings.Trim(tag, " ")
				if tag != "" {
					alias := fmt.Sprintf("%s:%s", p.args.ImageName, tag)
					options = append(options, "--tag", alias)
					targets = append(targets, alias)
				}
			}
		}
	}

	if p.args.WorkingDir != "" {
		options = append(options, p.args.WorkingDir)
	} else {
		options = append(options, ".")
	}

	out, err := p.do(options...)
	if err != nil {
		fmt.Printf("%s: %s", out, err)
		return err
	}

	if !p.args.DisablePush {
		if err := p.push(targets); err != nil {
			return err
		}
	}

	return nil
}

func getCredentialsFromEnv() (string, string) {
	username := os.Getenv("DOCKER_USERNAME")
	if username == "" {
		fmt.Printf("WARN: DOCKER_USERNAME is not set\n")
	}
	password := os.Getenv("DOCKER_PASSWORD")
	if password == "" {
		fmt.Printf("WARN: DOCKER_PASSWORD is not set\n")
	}
	return username, password
}

func (p *Podman) push(targets []string) error {
	username, password := getCredentialsFromEnv()
	_, err := p.do("login", "--username", username, "--password", password, p.args.ImageName)
	if err != nil {
		fmt.Printf("WARN: %s", err)
	}
	if p.args.Platform != "" {
		for _, target := range targets {
			_, err := p.do("manifest", "push", "--all", target)
			if err != nil {
				fmt.Printf("ERROR: %s", err)
				return err
			}
		}
	} else {
		for _, target := range targets {
			_, err := p.do("push", target)
			if err != nil {
				fmt.Printf("ERROR: %s", err)
				return err
			}
		}
	}

	return nil
}

func (p *Podman) Push() error {
	return nil
}

func (p *Podman) do(args ...string) (string, error) {
	out, err := p.execFn("podman", args...)
	fmt.Printf("%s\n", out)
	return string(out), err
}
