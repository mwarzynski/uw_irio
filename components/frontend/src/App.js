import React, { useState, useEffect } from 'react';
import AppBar from '@material-ui/core/AppBar';
import Grid from '@material-ui/core/Grid';
import Card from '@material-ui/core/Card';
import CardActionArea from '@material-ui/core/CardActionArea';
import CardContent from '@material-ui/core/CardContent';
import CssBaseline from '@material-ui/core/CssBaseline';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import { makeStyles } from '@material-ui/core/styles';
import { Container } from '@material-ui/core';

const useStyles = makeStyles((theme) => ({
  root: {
    display: 'flex',
  },
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
}));

function App() {
  const classes = useStyles();

  const [isLoaded, setIsLoaded] = useState(false);
  const [error, setError] = useState(null);
  const [news, setNews] = useState([]);

  useEffect(() => {
    fetch("https://us-central1-irio-project.cloudfunctions.net/frontend-api")
      .then(response => response.json())
      .then(
        (result) => {
          setIsLoaded(true);
          setNews(result["news"]);
        },
        (error) => {
          setIsLoaded(true);
          setError(error);
        }
      )
  }, [])

  let containerBody;

  if (error) {
    containerBody = <div>Error: {error.message}.</div>;
  } else if (!isLoaded) {
    containerBody = <div>Loading...</div>;
  } else {
    containerBody = <Grid container spacing={1} direction="row" justify="center">
      {news.map(n => (
        <Grid item xs={12} container direction="column" className={classes.grid} key={n.title}>
          <Card className={classes.root}>
            <CardActionArea onClick={() => window.open(n.url)}>
              <CardContent>
                <Typography variant="body1" component="h2">
                  {n.title}
                </Typography>
                <Typography className={classes.pos} color="textSecondary">
                  {n.publishedDate}
                </Typography>
              </CardContent>
            </CardActionArea>
          </Card>
        </Grid>
      ))}
    </Grid>
  }

  return (
    <div className={classes.root}>
      <CssBaseline />
      <AppBar position="fixed" style={{ background: '#ffffff' }}>
        <Toolbar>
          <Typography variant="h6" noWrap style={{
            "content": "url(https://www.gstatic.com/images/branding/googlelogo/svg/googlelogo_clr_74x24px.svg)"}}>
          </Typography>
          <Typography style={{
            "color": '#5f6368',
            "display": "inline-block",
            "font-family": "'Product Sans',Arial,sans-serif",
            "font-size": "22px",
            "line-height": "24px",
            "padding-left": "4px",
            "position": "relative",
            "top": "-1.5px",
            "font-weight": "400",
            "vertical-align": "middle"}}>
             News
            </Typography>
        </Toolbar>
      </AppBar>
      <main className={classes.content}>
        <div className={classes.toolbar} />
        <Container>
          {containerBody}
        </Container>
      </main>
    </div>
  );
}

export default App;