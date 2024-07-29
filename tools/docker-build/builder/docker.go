package builder

var _ runtime = &Docker{}

type Docker struct {
}

func (d *Docker) WithArgs(a Args) runtime {
	return d
}

func (d *Docker) Build() error {
	return nil
}

func (d *Docker) Push() error {
	return nil
}
