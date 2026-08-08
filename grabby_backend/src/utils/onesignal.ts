import axios from 'axios';
import config from '../config';

export const sendNotificationOnesignal = async (
  playerIds: string[],
  title: { eng: string;[key: string]: string },
  message: { eng: string;[key: string]: string },
  route?: string,
  getId?: string,
  notice?: string
) => {


  const data = {
    app_id: config.onesignal.app_id,
    contents: { en: message.eng },
    headings: { en: title.eng },
    include_player_ids: playerIds,
    target_channel: 'push',
    data: {
      route: route || '',
      getId: getId || '',
      notice: notice || '',
    },
  };

  const headers = {
    Authorization: `Basic ${config.onesignal.api_key}`,
    'Content-Type': 'application/json',
  };

  try {
    const response = await axios.post(
      `${config.onesignal.onesignal_url}/api/v1/notifications`,
      data,
      { headers }
    );
    return response.data;
  } catch (error) {
    console.error('Error sending notification:', error);
  }
};
