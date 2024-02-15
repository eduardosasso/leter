interface BaseConfig {
  bear: {
    database: string;
    tags: {
      post: string;
      home: string;
    };
  };
}

interface JsonConfig extends BaseConfig {
  projects: {
    tag: string;
    path: string;
  }[];
}

interface Config extends BaseConfig {
  projects: {
    [key: string]: string;
  };
}

interface BaseItem {
  description: string;
  text: string;
  created: Date;
  updated: Date;
}

interface Item extends BaseItem {
  title: string;
  tags: string[];
  type: ItemType;
}

interface Note extends BaseItem{
  tags: string;
}

enum ItemType {
  Post = 'post',
  Home = 'home'
}

export { JsonConfig, Config, Note, Item, ItemType };