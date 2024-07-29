package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/spf13/pflag"
	"github.com/spf13/viper"

	"github.com/daocloud/amamba-jenkins/tools/docker-build/builder"
)

func main() {
	var args builder.Args
	pflag.StringVar(&args.ImageName, "image", "", "the image name")
	pflag.StringVar(&args.Tag, "tag", "latest", "the image tag")
	pflag.StringArrayVar(&args.Tags, "tags", nil, "the image tags, only works when platform is not specified")
	pflag.StringVar(&args.Dockerfile, "dockerfile", "Dockerfile", "dockerfile")
	pflag.BoolVar(&args.DisablePush, "disable-push", false, "disable push")
	pflag.BoolVar(&args.NoCache, "no-cache", false, "no cache")
	pflag.StringVar(&args.BuildArgs, "build-args", "", "build args")
	pflag.StringVar(&args.Platform, "platform", "", "platform")
	pflag.StringVar(&args.WorkingDir, "working-dir", ".", "working dir")

	pflag.Parse()

	f := pflag.CommandLine
	normalizeFunc := f.GetNormalizeFunc()
	f.SetNormalizeFunc(func(fs *pflag.FlagSet, name string) pflag.NormalizedName {
		result := normalizeFunc(fs, name)
		name = strings.ReplaceAll(string(result), "-", "_")
		return pflag.NormalizedName(name)
	})
	viper.BindPFlags(f)
	viper.AutomaticEnv()
	err := viper.Unmarshal(&args)
	if err != nil {
		fmt.Printf("%s: %v", err, args)
		os.Exit(1)
	}
	fmt.Printf("Run with args: %#v", args)
	err = builder.Runtime().WithArgs(args).Build()
	if err != nil {
		fmt.Printf("%s", err)
	}
}
