package builder

import (
	"os"
	"reflect"
	"testing"

	"github.com/google/go-cmp/cmp"
)

func TestPodman_Build(t *testing.T) {
	os.Setenv("DOCKER_USERNAME", "admin")
	os.Setenv("DOCKER_PASSWORD", "password")
	tests := []struct {
		name    string
		args    Args
		envs    map[string]string
		want    []string
		wantErr bool
	}{
		{
			name: "build with tags",
			args: Args{
				ImageName:   "test",
				Tag:         "v1.0",
				Tags:        []string{"latest", "v1.0-dev"},
				NoCache:     true,
				DisablePush: true,
				Dockerfile:  "Dockerfile.test",
				BuildArgs:   "--build-arg key1=val1,key2=val2",
				WorkingDir:  "test/",
			},
			want: []string{
				"podman build --network=host -f Dockerfile.test --no-cache --build-arg key1=val1,key2=val2 --tag test:v1.0 --tag test:latest --tag test:v1.0-dev test/",
			},
		},
		{
			name: "build multi-platform",
			args: Args{
				ImageName:   "test",
				Tag:         "v1.0",
				DisablePush: true,
				Platform:    "linux/amd64,linux/arm64",
			},
			want: []string{
				"podman build --network=host --platform linux/amd64,linux/arm64 --manifest test:v1.0 .",
			},
		},
		{
			name: "build and push tags",
			args: Args{
				ImageName: "test",
				Tag:       "v1.0",
				Tags:      []string{"latest", "v1.0-dev"},
			},
			want: []string{
				"podman build --network=host --tag test:v1.0 --tag test:latest --tag test:v1.0-dev .",
				"podman login --username admin --password password test",
				"podman push test:v1.0",
				"podman push test:latest",
				"podman push test:v1.0-dev",
			},
		},
		{
			name: "build and push multi-platform images",
			args: Args{
				ImageName: "test",
				Tag:       "v1.0",
				Tags:      []string{"a", "b"},
				Platform:  "linux/amd64,linux/arm64",
			},
			want: []string{
				"podman build --network=host --platform linux/amd64,linux/arm64 --manifest test:v1.0 .",
				"podman login --username admin --password password test",
				"podman manifest push --all test:v1.0",
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			f := &fakeCmd{
				history: []string{},
			}
			p := &Podman{
				args:   tt.args,
				execFn: f.execCmd,
			}
			if err := p.Build(); (err != nil) != tt.wantErr {
				t.Errorf("Podman.Build() error = %v, wantErr %v", err, tt.wantErr)
			}
			if !reflect.DeepEqual(f.history, tt.want) {
				t.Errorf("got differ than expected: %s", cmp.Diff(f.history, tt.want))
			}
		})
	}
}
