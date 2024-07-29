package builder

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

type runtime interface {
	WithArgs(args Args) runtime
	Build() error
	Push() error
}

func Runtime() runtime {
	if _, err := os.Stat("/var/run/docker.sock"); errors.Is(err, os.ErrNotExist) {
		fmt.Println("Using runtime podman")
		return NewPodman()
	}
	fmt.Printf("Using runtime docker")
	return &Docker{}
}

type Args struct {
	ImageName   string   `json:"image_name"`
	Tag         string   `json:"tag"`
	Tags        []string `json:"tags"`
	Dockerfile  string   `json:"dockerfile"`
	DisablePush bool     `mapstructure:"DISABLE_PUSH" json:"disable_push"`
	NoCache     bool     `mapstructure:"NO_CACHE" json:"no_cache"`
	BuildArgs   string   `mapstructure:"BUILD_ARGS" json:"build_args"`
	Platform    string   `json:"platform"`
	WorkingDir  string   `mapstructure:"WORKING_DIR" json:"working_dir"`
}

type execFn func(cmd string, args ...string) ([]byte, error)

func execCmd(cmd string, args ...string) ([]byte, error) {
	printArgs := make([]string, 0, len(args))
	for i := range args {
		if i > 1 && args[i-1] == "--password" {
			printArgs = append(printArgs, "***")
		} else {
			printArgs = append(printArgs, args[i])
		}
	}
	fmt.Printf("%s %v\n", cmd, printArgs)
	return exec.Command(cmd, args...).CombinedOutput()
}

type fakeCmd struct {
	history []string
}

func (f *fakeCmd) execCmd(cmd string, args ...string) ([]byte, error) {
	cmdline := cmd + " " + strings.Join(args, " ")
	f.history = append(f.history, cmdline)
	return nil, nil
}
